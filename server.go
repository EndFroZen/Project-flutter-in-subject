package main

import (
	"log"
	api "server/components"
	"server/components/database"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()
	database.ConnectDatabase()
	app.Post("/login",api.Login)
	log.Println(api.UserID)
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("HELLO EF")
	})
	app.Get("/api/tredeitem", api.ShowItem)
	app.Get("/api/tredeitem/id/:itemid", api.Show_A_Item)
	app.Get("/api/image/:id", func(c *fiber.Ctx) error {
		idImg := c.Params("id")
		return c.SendFile("./image/" + idImg)
	})
	// app.Listen("0.0.0.0:3023")
	// app.Listen("127.0.0.1:4050")
	app.Listen("0.0.0.0:4050")
}
