package database

import (
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"strings"
	"time"

	"gorm.io/gorm"
)

type ItemInfo struct {
	gorm.Model
	Name        string
	Discription string
	Location    string
	Imagepath   string
	UserInfoID  uint
	UserInfo    UserInfo
}

func PostItem(db *gorm.DB, item *ItemInfo) error {
	result := db.Create(&item)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func GetAllItem(db *gorm.DB, userId int) ([]ItemInfo, error) {
	var items []ItemInfo
	result := db.Where("user_info_id != ?", userId).Preload("UserInfo").Find(&items)
	if result.Error != nil {
		return nil, result.Error
	}
	return items, nil
}

func GetSomeItem(db *gorm.DB, itemID int) ([]ItemInfo, error) {
	var items []ItemInfo
	result := db.Where("id = ?", itemID).Preload("UserInfo").First(&items)
	if result.Error != nil {
		return nil, result.Error
	}
	return items, nil
}
func GetMyItem(db *gorm.DB, userId int) ([]ItemInfo, error) {
	var items []ItemInfo
	result := db.Where("user_info_id = ?", userId).Preload("UserInfo").Find(&items)
	if result.Error != nil {
		return nil, result.Error
	}
	return items, nil
}

func Savefileimage(base64file string, userID int) string {
	if strings.HasPrefix(base64file, "data:image/jpeg") {
		decodedData := strings.SplitN(base64file, ",", 2)[1]
		fileData, err := base64.StdEncoding.DecodeString(decodedData)
		if err != nil {
			return ""
		}
		fileName := fmt.Sprintf("/item/%d-userID%d.jpg", time.Now().UnixNano(), userID)
		pathfilename := fmt.Sprintf("./image%s", fileName)
		err = ioutil.WriteFile(pathfilename, fileData, 0644)
		if err != nil {
			return ""
		}
		return fileName
	} else if strings.HasPrefix(base64file, "data:image/png") {
		decodedData := strings.SplitN(base64file, ",", 2)[1]
		fileData, err := base64.StdEncoding.DecodeString(decodedData)
		if err != nil {
			return ""
		}
		fileName := fmt.Sprintf("/item/%d-userID%d.png", time.Now().UnixNano(), userID)
		pathfilename := fmt.Sprintf("./image%s", fileName)
		err = ioutil.WriteFile(pathfilename, fileData, 0644)
		if err != nil {
			return ""
		}
		return fileName
	}
	return ""
}
