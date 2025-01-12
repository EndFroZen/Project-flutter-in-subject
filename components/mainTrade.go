package api

import "github.com/gofiber/fiber/v2"

type ItemTrade struct {
	Name string `json:"name"`
	Date string `json:"date"`
	Img  string `json:"img"`
}

func ShowItem(c *fiber.Ctx) error {
	item := []ItemTrade{{Name: "วาซาบิ", Date: "10/10/2555", Img: "1.png"}}
	item = append(item, ItemTrade{Name: "ไก่",Date: "11/10/2555",Img: "2.png"})
	item = append(item, ItemTrade{Name: "ผ้าห่ม",Date: "12/10/2555",Img: "3.png"})
	item = append(item, ItemTrade{Name: "ส้ม",Date: "11/10/2555",Img: "4.png"})
	item = append(item, ItemTrade{Name: "กันดีด",Date: "5/10/2555",Img: "5.png"})
	return c.JSON(item)
}
