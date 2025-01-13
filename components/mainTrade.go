package api

import (
	"log"
	"server/components/database"

	"github.com/gofiber/fiber/v2"
)

type ItemTrade struct {
	Name string `json:"name"`
	Date string `json:"date"`
	Img  string `json:"img"`
}

func ShowItem(c *fiber.Ctx) error {
	item,err := database.ShowItem()
	if err != nil{
		return c.Status(fiber.StatusBadRequest).SendString("Invalid input: " + err.Error())
	}
	return c.JSON(item)
}
func Show_A_Item(c *fiber.Ctx) error {
	iditem := c.Params("itemid")
	log.Printf(iditem)
	item,err := database.ShowAItem(iditem)
	if err != nil{
		return c.Status(fiber.StatusBadRequest).SendString("Invalid input: " + err.Error())
	}
	return c.JSON(item)
}