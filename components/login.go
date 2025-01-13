package api

import (
	"server/components/database"

	"github.com/gofiber/fiber/v2"
)
var UserID uint
func Login(c *fiber.Ctx) error {

	type LoginRequest struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	var data LoginRequest
	if err := c.BodyParser(&data); err != nil {
		return c.Status(fiber.StatusBadRequest).SendString("Invalid input: " + err.Error())
	}
	ID, isValid, err := database.LoginCheck(data.Email, data.Password)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).SendString("Invalid input: " + err.Error())
	}

	if isValid {
		UserID = ID
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"message": "Login successful",
		})
	}

	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"error": "Invalid email or password",
	})
}
