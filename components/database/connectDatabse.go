package database

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv" 
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func ConnectDatabase() *gorm.DB {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), 
		logger.Config{
			SlowThreshold: time.Second,   // Slow SQL threshold
			LogLevel:      logger.Silent, // Log level
			Colorful:      true,          
		},
	)
	// USERNAME := os.Getenv("USERNAME")
	PASSWORD := os.Getenv("PASSWORD")
	// PORT := os.Getenv("PORT")

	dsn := fmt.Sprintf("root:%s@tcp(127.0.0.1:3306)/tradeon?parseTime=true", PASSWORD)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{Logger: newLogger})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	log.Println("Database connection established and schema migrated successfully!")
	return db
}
