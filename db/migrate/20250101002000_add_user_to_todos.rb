class AddUserToTodos < ActiveRecord::Migration[7.1]
  def up
    add_reference :todos, :user, null: true, foreign_key: true

    admin_user = User.find_or_create_by!(email: "admin@todo.lab") do |user|
      user.name = "Administrator"
      user.password = "654321"
      user.password_confirmation = "654321"
      user.admin = true
    end

    Todo.update_all(user_id: admin_user.id)

    change_column_null :todos, :user_id, false
  end

  def down
    change_column_null :todos, :user_id, true
    remove_reference :todos, :user, foreign_key: true
  end
end
