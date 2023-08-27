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

ActiveRecord::Schema[7.0].define(version: 2023_08_27_084831) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "llm_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "llm_message_type"
    t.uuid "source_id"
    t.string "source_type"
    t.text "prompt", null: false
    t.jsonb "response"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["llm_message_type"], name: "index_llm_messages_on_llm_message_type"
    t.index ["source_id", "source_type"], name: "index_llm_messages_on_source"
  end

  create_table "stories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url", null: false
    t.string "domain"
    t.string "status", default: "drafted", null: false
    t.jsonb "source", default: {}, null: false
    t.text "html"
    t.string "title"
    t.datetime "published_at"
    t.string "locale", default: "en", null: false
    t.string "story_type", default: "fact", null: false
    t.string "sentiment", default: "neutral"
    t.integer "score", default: 5, null: false
    t.text "summary"
    t.uuid "topic_id"
    t.vector "embedding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sentiment"], name: "index_stories_on_sentiment"
    t.index ["story_type"], name: "index_stories_on_story_type"
    t.index ["topic_id"], name: "index_stories_on_topic_id"
    t.index ["url"], name: "index_stories_on_url", unique: true
  end

  create_table "taggings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tag_id", null: false
    t.uuid "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "index_taggings_on_tag_id_and_taggable", unique: true
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "translations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "translatable_id", null: false
    t.string "translatable_type", null: false
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_translations_on_translatable_and_locale_and_key", unique: true
  end

end
