package repositories

import (
	role "general-service/internal/common/constants"
	"general-service/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type RBACRepository struct {
	db *gorm.DB
}

func NewRBACRepository(db *gorm.DB) *RBACRepository {
	return &RBACRepository{db: db}
}

func (r *RBACRepository) CountPermissions() (int64, error) {
	var count int64
	err := r.db.Model(&models.Permission{}).Count(&count).Error
	return count, err
}

func (r *RBACRepository) ListPermissions() ([]models.Permission, error) {
	var permissions []models.Permission
	err := r.db.Order("code asc").Find(&permissions).Error
	return permissions, err
}

func (r *RBACRepository) ListRolePermissions(role role.UserRole) ([]string, error) {
	var rows []models.RolePermission
	if err := r.db.Where("role = ?", role).Find(&rows).Error; err != nil {
		return nil, err
	}
	codes := make([]string, len(rows))
	for i, row := range rows {
		codes[i] = row.PermissionCode
	}
	return codes, nil
}

func (r *RBACRepository) ReplaceRolePermissions(role role.UserRole, codes []string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("role = ?", role).Delete(&models.RolePermission{}).Error; err != nil {
			return err
		}
		for _, code := range codes {
			if err := tx.Create(&models.RolePermission{
				Role:           role,
				PermissionCode: code,
			}).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *RBACRepository) ListUserPermissions(userID uuid.UUID) ([]string, error) {
	var rows []models.UserPermission
	if err := r.db.Where("user_id = ?", userID).Find(&rows).Error; err != nil {
		return nil, err
	}
	codes := make([]string, len(rows))
	for i, row := range rows {
		codes[i] = row.PermissionCode
	}
	return codes, nil
}

func (r *RBACRepository) HasUserPermissionOverrides(userID uuid.UUID) (bool, error) {
	var count int64
	if err := r.db.Model(&models.UserPermission{}).Where("user_id = ?", userID).Count(&count).Error; err != nil {
		return false, err
	}
	return count > 0, nil
}

func (r *RBACRepository) ReplaceUserPermissions(userID uuid.UUID, codes []string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("user_id = ?", userID).Delete(&models.UserPermission{}).Error; err != nil {
			return err
		}
		for _, code := range codes {
			if err := tx.Create(&models.UserPermission{
				UserID:         userID,
				PermissionCode: code,
			}).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *RBACRepository) ClearUserPermissions(userID uuid.UUID) error {
	return r.db.Where("user_id = ?", userID).Delete(&models.UserPermission{}).Error
}

func (r *RBACRepository) UpsertPermission(permission *models.Permission) error {
	return r.db.Save(permission).Error
}

func (r *RBACRepository) UpsertRolePermission(role role.UserRole, code string) error {
	row := models.RolePermission{Role: role, PermissionCode: code}
	return r.db.Where("role = ? AND permission_code = ?", role, code).
		FirstOrCreate(&row).Error
}
