package database

import (
	"log"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

type UserInfo struct {
	ID       uint       `gorm:"primaryKey"`
	Name     string     `gorm:"column:name"`
	Email    string     `gorm:"column:email"`
	Password string     `gorm:"column:password"`
	Items    []ItemInfo `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

type ItemInfo struct {
	gorm.Model
	NameItem        string   `gorm:"column:nameitem"`
	DescriptionItem string   `gorm:"column:descriptionitem"`
	Image           string   `gorm:"column:image"`
	Pathitem        string   `gorm:"column:pathitem"`
	UserID          uint     `gorm:"column:user_id"`
	User            UserInfo `gorm:"foreignKey:UserID;references:ID"`
}

func ConnectDatabase() {
	dsn := "root:Ef162546_@tcp(127.0.0.1:3306)/tradeon?parseTime=true"
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	DB = db
	err = DB.AutoMigrate(&UserInfo{}, &ItemInfo{})
	if err != nil {
		log.Fatalf("Failed to migrate database schema: %v", err)
	}

	log.Println("Database connection established and schema migrated successfully!")
	// insert();
}

func ShowUserInfo() {
	var users []UserInfo
	if err := DB.Table("user_infos").Find(&users).Error; err != nil {
		log.Fatalf("Failed to retrieve data: %v", err)
	}
	for _, user := range users {
		log.Printf("ID: %d, Name: %s, Email: %s,Password: %s", user.ID, user.Name, user.Email, user.Password)
	}
}

func LoginCheck(email, password string) (uint, bool, error) {
	var user UserInfo
	if err := DB.Table("user_infos").Where("email = ? AND password = ?", email, password).First(&user).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			log.Printf("Invalid login: email=%s", email)
			return 0, false, nil
		}
		log.Printf("Error checking login: %v", err)
		return 0, false, err
	}
	log.Printf("Login successful: ID=%d, Name=%s, Email=%s", user.ID, user.Name, user.Email)
	return user.ID, true, nil
}

func ShowItem() ([]ItemInfo, error) {
	var item []ItemInfo
	if err := DB.Table("item_infos").Find(&item).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil 
		}
		return nil, err
	}
	return item ,nil
}
func ShowAItem(iditem string) ([]ItemInfo, error) {
	var item []ItemInfo
	if err := DB.Table("item_infos").Where("id = ?",iditem).Find(&item).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil 
		}
		return nil, err
	}
	return item ,nil
}


