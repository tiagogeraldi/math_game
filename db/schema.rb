# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_214_153_000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'games', force: :cascade do |t|
    t.integer 'user_one_id'
    t.integer 'user_two_id'
    t.integer 'user_one_points', default: 0
    t.integer 'user_two_points', default: 0
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'canceled', default: false
    t.integer 'invite_id'
    t.boolean 'finished', default: false
    t.index ['invite_id'], name: 'index_games_on_invite_id'
    t.index ['user_one_id'], name: 'index_games_on_user_one_id'
    t.index ['user_two_id'], name: 'index_games_on_user_two_id'
  end

  create_table 'invites', force: :cascade do |t|
    t.integer 'from_id'
    t.integer 'to_id'
    t.boolean 'accepted'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'from_ready'
    t.boolean 'to_ready'
    t.index ['from_id'], name: 'index_invites_on_from_id'
    t.index ['to_id'], name: 'index_invites_on_to_id'
  end

  create_table 'rounds', force: :cascade do |t|
    t.bigint 'game_id', null: false
    t.float 'user_one_answer'
    t.float 'user_two_answer'
    t.string 'description'
    t.float 'correct_answer'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'current', default: false
    t.integer 'alternatives', default: [], array: true
    t.index ['game_id'], name: 'index_rounds_on_game_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.boolean 'playing', default: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'games', 'invites'
  add_foreign_key 'games', 'users', column: 'user_one_id'
  add_foreign_key 'games', 'users', column: 'user_two_id'
  add_foreign_key 'invites', 'users', column: 'from_id'
  add_foreign_key 'invites', 'users', column: 'to_id'
  add_foreign_key 'rounds', 'games'
end
