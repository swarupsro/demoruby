# frozen_string_literal: true

admin_email = "admin@todo.lab"
admin_name = "Administrator"
admin_password = "654321"

admin = User.find_or_initialize_by(email: admin_email)
admin.name = admin_name
admin.password = admin_password
admin.password_confirmation = admin_password
admin.admin = true
admin.save!
