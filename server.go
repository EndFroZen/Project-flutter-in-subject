package main

import (
	"fmt"
	"log"
	"os"
	"server/components/database"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/golang-jwt/jwt/v5"
	"github.com/joho/godotenv"
)

func init() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}
}

func authendicationMethod(c *fiber.Ctx) error {

	authHeader := c.Query("Auth")
	KEY := os.Getenv("KEY")
	secretKey := []byte(KEY)
	if authHeader == "" {
		return c.Status(fiber.StatusUnauthorized).SendString("No token provided")
	}
	token, err := jwt.ParseWithClaims(authHeader, jwt.MapClaims{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})
	if err != nil || !token.Valid {
		return c.SendStatus(fiber.ErrUnauthorized.Code)
	}
	claim := token.Claims.(jwt.MapClaims)
	email := claim["iss"].(string)
	fmt.Println(email)
	c.Locals("email", email)
	return c.Next()
}

func main() {

	app := fiber.New()
	DB := database.ConnectDatabase()
	DB.AutoMigrate(&database.UserInfo{}, database.ItemInfo{}, database.TradeInfo{}, database.SendingAdding{})
	app.Static("/image", "./image")
	// log.Fatal(DB)
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",                          // อนุญาตให้ทุกโดเมนเข้าถึง (ระวังเรื่องความปลอดภัย)
		AllowMethods: "GET,POST,PUT,DELETE",        // อนุญาตเฉพาะเมธอดที่ต้องการ
		AllowHeaders: "Content-Type,Authorization", // อนุญาตให้ส่ง headers พิเศษ เช่น Authorization
	}))
	// app use-------------------------------------------------------------------------------------
	app.Use("/postitem", authendicationMethod)
	app.Use("/api/allitem", authendicationMethod)
	app.Use("/api/someitem/:itemid", authendicationMethod)
	app.Use("/api/myitem", authendicationMethod)
	app.Use("/trade", authendicationMethod)
	app.Use("/trade/waiting", authendicationMethod)
	app.Use("/trade/update", authendicationMethod)
	app.Use("/trade/dealer", authendicationMethod)
	app.Use("/trade/dealer/someitem/:id", authendicationMethod)
	app.Use("/trade/dealer/sendingadd", authendicationMethod)
	// app use-------------------------------------------------------------------------------------

	// user ----------------------------------------------------------------------------------------
	app.Post("/register", func(c *fiber.Ctx) error {
		user := new(database.UserInfo)

		if err := c.BodyParser(&user); err != nil {
			return c.Status(fiber.StatusBadRequest).SendString(err.Error())
		}
		err := database.Register(DB, user)
		if err != nil {
			return c.Status(fiber.StatusBadRequest).SendString(err.Error())
		}
		return c.JSON(fiber.Map{
			"status": "registor successful",
		})

	})
	app.Post("/login", func(c *fiber.Ctx) error {
		user := new(database.UserInfo)
		if err := c.BodyParser(&user); err != nil {
			return c.JSON(fiber.Map{
				"token": nil,
			})
		}
		token, err := database.Login(DB, user)
		if err != nil {
			return c.JSON(fiber.Map{
				"token": nil,
			})
		}
		return c.JSON(fiber.Map{
			"token": token,
		})
	})

	// user ----------------------------------------------------------------------------------------

	// get data ------------------------------------------------------------------------------------
	app.Get("/api/allitem", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		allItem, err := database.GetAllItem(DB, int(userData.ID))
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /api/allitem",
				"detail": err.Error(),
			})
		}
		fmt.Printf("GET /api/allitem AT %s by %s\n", time.Now(), userData.Email)
		return c.JSON(allItem)
	})
	app.Get("/api/someitem/:itemid", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		itemID, err := c.ParamsInt("itemid")
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /api/someitem/:itemid",
				"detail": err.Error(),
			})
		}
		someitem, err := database.GetSomeItem(DB, itemID)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /api/someitem/:itemid",
				"detail": err.Error(),
			})
		}
		fmt.Printf("GET /api/someitem/%d AT %s by %s\n", itemID, time.Now(), userData.Email)
		return c.JSON(someitem)
	})
	app.Get("/api/myitem", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		myitem, err := database.GetMyItem(DB, int(userData.ID))
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /api/allitem",
				"detail": err.Error(),
			})
		}
		fmt.Printf("GET /api/myitem AT %s by %s\n", time.Now(), userData.Email)
		return c.JSON(fiber.Map{
			"user": userData,
			"item": myitem,
		})

	})
	app.Get("/api/image/item/:imagepath", func(c *fiber.Ctx) error {
		imagePath := c.Params("imagepath")
		fmt.Println(imagePath)
		return c.SendFile("./image/item/" + imagePath)
	})
	app.Get("/trade/waiting", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		tradewaiting, err := database.GetTradeWaiting(DB, int(userData.ID))
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error",
				"detail": err.Error(),
			})
		}
		return c.JSON(tradewaiting)
	})
	app.Get("/trade/dealer", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		traddealer, err := database.GetTradeDealer(DB, int(userData.ID))
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error",
				"detail": err.Error(),
			})
		}
		return c.JSON(traddealer)
	})
	app.Get("/trade/dealer/someitem/:id", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		iddealer, _ := c.ParamsInt("id")
		traddealersomeitem, err := database.GetSomeTradeDealer(DB, int(userData.ID), iddealer)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error",
				"detail": err.Error(),
			})
		}
		return c.JSON(traddealersomeitem)
	})
	// get data ------------------------------------------------------------------------------------

	// post data -----------------------------------------------------------------------------------
	app.Post("/postitem", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, err := database.GetUserByEmail(DB, email)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /user",
				"detail": err.Error(),
			})
		}
		var req map[string]interface{}
		if err := c.BodyParser(&req); err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /postitem",
				"detail": err.Error(),
			})
		}
		base64file := req["file"]
		name := req["name"]
		location := req["location"]
		discription := req["description"]
		fmt.Println(name)
		fmt.Println(location)
		fmt.Println(discription)

		imagepath := database.Savefileimage(base64file.(string), int(userData.ID))
		
		itemJson := &database.ItemInfo{
			Name:        name.(string),
			Discription: discription.(string),
			Location:    location.(string),
			Imagepath:   imagepath,
			UserInfoID:  userData.ID,
		}
		fmt.Printf("POST /postitem AT %s by %s\n", time.Now(), userData.Email)
		_ = database.PostItem(DB, itemJson)
		// fmt.Println(itemJson)

		return c.JSON(fiber.Map{
			"status": userData.Email,
		})
	})
	app.Post("/trade", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		// fmt.Println(userData.ID)
		var req map[string]interface{}
		if err := c.BodyParser(&req); err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /trade",
				"detail": err.Error(),
			})
		}
		// fmt.Println(req)
		userownerid := req["userownerid"].(float64)
		owneritemid := req["owneritemid"].(float64)
		tradeitemid := req["tradeitemid"].(float64)
		tradeJson := &database.TradeInfo{
			UserTraderID: userData.ID,
			UserOwnerID:  uint(userownerid),
			OwnerItemID:  uint(owneritemid),
			TradeItemID:  uint(tradeitemid),
			StatusTrade:  req["statustrade"].(string),
		}
		fmt.Println(tradeJson)
		err := database.TradeStatus(DB, tradeJson)
		// fmt.Println(itemJson)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at adding trade",
				"detail": err.Error(),
			})
		}
		return c.JSON(fiber.Map{
			"status": "trade succesfull",
		})
	})
	app.Put("/trade/update", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		// fmt.Println(userData.ID)
		var req map[string]interface{}
		if err := c.BodyParser(&req); err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /trade",
				"detail": err.Error(),
			})
		}
		// fmt.Println(req)
		userownerid := req["userownerid"].(float64)
		owneritemid := req["owneritemid"].(float64)
		tradeitemid := req["tradeitemid"].(float64)
		tradeJson := &database.TradeInfo{
			UserTraderID: userData.ID,
			UserOwnerID:  uint(userownerid),
			OwnerItemID:  uint(owneritemid),
			TradeItemID:  uint(tradeitemid),
			StatusTrade:  req["statustrade"].(string),
		}
		fmt.Println(tradeJson)
		err := database.UpdateStatusTrade(DB, tradeJson)
		// fmt.Println(itemJson)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at updating",
				"detail": err.Error(),
			})
		}
		return c.JSON(fiber.Map{
			"status": "trade succesfull",
		})
	})
	app.Post("/trade/dealer/sendingadd", func(c *fiber.Ctx) error {
		email := c.Locals("email").(string)
		userData, _ := database.GetUserByEmail(DB, email)
		fmt.Println(userData.ID)
		var req map[string]interface{}
		if err := c.BodyParser(&req); err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at /trade",
				"detail": err.Error(),
			})
		}
		dealerid := req["dealerid"].(float64)
		sendingjson := &database.SendingAdding{
			BoxAdd:     req["boxadd"].(string),
			MoreAdd:    req["moreadd"].(string),
			UserPostID: userData.ID,
			DealerID:   uint(dealerid),
		}
		err := database.SendingaddTrade(DB, sendingjson)
		// fmt.Println(itemJson)
		if err != nil {
			return c.JSON(fiber.Map{
				"status": "Error at updating",
				"detail": err.Error(),
			})
		}
		return c.JSON(fiber.Map{
			"status": "trade succesfull",
		})
	})
	// post data -----------------------------------------------------------------------------------

	//port------------------------------------------------------------------------------------------

	app.Listen("0.0.0.0:3023")
	// app.Listen("127.0.0.1:4050")
	// app.Listen("0.0.0.0:4050")

	//port------------------------------------------------------------------------------------------
}
