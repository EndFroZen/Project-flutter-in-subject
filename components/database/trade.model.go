package database

import (
	"fmt"

	"gorm.io/gorm"
)

type TradeInfo struct {
	gorm.Model
	UserTraderID uint
	UserOwnerID  uint
	OwnerItemID  uint
	TradeItemID  uint
	StatusTrade  string
	User1        UserInfo `gorm:"foreignKey:UserTraderID;references:ID"`
	User2        UserInfo `gorm:"foreignKey:UserOwnerID;references:ID"`
	Item1        ItemInfo `gorm:"foreignKey:OwnerItemID;references:ID"`
	Item2        ItemInfo `gorm:"foreignKey:TradeItemID;references:ID"`
}

type SendingAdding struct {
	gorm.Model
	DealerID   uint
	UserPostID uint
	MoreAdd    string
	BoxAdd     string
	TradeID    TradeInfo `gorm:"foreignKey:DealerID;references:ID"`
	UserID     UserInfo  `gorm:"foreignKey:UserPostID;references:ID"`
}

func TradeStatus(db *gorm.DB, trade *TradeInfo) error {
	fmt.Println("awdkjawgiudgafdfawytd", trade)
	result := db.Create(&trade)

	if result.Error != nil {
		return result.Error
	}
	return nil
}

func GetTradeWaiting(db *gorm.DB, userID int) ([]TradeInfo, error) {
	var dealers []TradeInfo
	// fmt.Println(userID)

	result := db.Debug().Where("user_owner_id = ? AND status_trade = ? ", userID, "waiting").
		Order("created_at DESC").
		Preload("User1").
		Preload("User2").
		Preload("Item1").
		Preload("Item1.UserInfo").
		Preload("Item2").
		Preload("Item2.UserInfo").
		Find(&dealers)

	if result.Error != nil {
		return nil, result.Error
	}
	return dealers, nil
}

func UpdateStatusTrade(db *gorm.DB, trade *TradeInfo) error {
	result := db.Model(&TradeInfo{}).
		Where("id = ? ", trade.UserTraderID).
		Update("status_trade", trade.StatusTrade)
	if result.Error != nil {
		return result.Error
	}

	// Check if any rows were updated
	if result.RowsAffected == 0 {
		return fmt.Errorf("no trade found to update with given parameters")
	}

	return nil
}

func GetTradeDealer(db *gorm.DB, userID int) ([]TradeInfo, error) {
	var dealers []TradeInfo
	// fmt.Println(userID)

	result := db.Debug().Unscoped().Where("(user_owner_id = ? OR user_trader_id = ? )AND status_trade = ? ", userID, userID, "dealer").
		Order("updated_at DESC").
		Preload("User1").
		Preload("User2").
		Preload("Item1").
		Preload("Item1.UserInfo").
		Preload("Item2").
		Preload("Item2.UserInfo").
		Find(&dealers)

	if result.Error != nil {
		return nil, result.Error
	}
	return dealers, nil
}

func GetSomeTradeDealer(db *gorm.DB, userID int, iddealer int) ([]TradeInfo, error) {
	var dealers []TradeInfo
	// fmt.Println(userID)

	result := db.Debug().Where("user_owner_id = ? AND status_trade = ? AND id = ?", userID, "dealer", iddealer).
		Preload("User1").
		Preload("User2").
		Preload("Item1").
		Preload("Item1.UserInfo").
		Preload("Item2").
		Preload("Item2.UserInfo").
		Find(&dealers)

	if result.Error != nil {
		return nil, result.Error
	}
	return dealers, nil
}

func SendingaddTrade(db *gorm.DB, SendingAdding *SendingAdding) error {
	result := db.Create(&SendingAdding)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func Deletedealer(db *gorm.DB) error {
	var trades []TradeInfo

	// Delete items related to 'dealer' status trades
	result := db.Where("status_trade = ?", "dealer").Find(&trades)
	if result.Error != nil {
		return result.Error
	}

	for _, trade := range trades {
		if err := db.Where("id = ?", trade.TradeItemID).Delete(&ItemInfo{}).Error; err != nil {
			return err
		}
		if err := db.Where("id = ?", trade.OwnerItemID).Delete(&ItemInfo{}).Error; err != nil {
			return err
		}
	}
	result = db.Where("status_trade = ?", "waiting").Find(&trades)
	if result.Error != nil {
		return result.Error
	}

	for _, trade := range trades {

		var item []ItemInfo
		if err := db.Where("id = ? AND deleted_at IS NOT NULL", trade.TradeItemID).First(&item).Error; err == nil {

			if err := db.Where("id = ?", trade.ID).Delete(&TradeInfo{}).Error; err != nil {
				return err
			}
		}

		if err := db.Where("id = ? AND deleted_at IS NOT NULL", trade.OwnerItemID).First(&item).Error; err == nil {
			// If the item is deleted, delete the related TradeInfo
			if err := db.Where("id = ?", trade.ID).Delete(&TradeInfo{}).Error; err != nil {
				return err
			}
		}
	}

	return nil
}
