package main

import (
	api "server/components"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()
	app.Get("/",func(c *fiber.Ctx) error {
		return c.SendString("HELLO EF")
	})
	app.Get("/api/itemtread",api.ShowItem)
	app.Get("/api/image/:id",func(c *fiber.Ctx) error {
		idImg := c.Params("id")
		return c.SendFile("./image/"+idImg)
	})
	app.Listen("0.0.0.0:3023")
	// app.Listen("127.0.0.1:4050")
}