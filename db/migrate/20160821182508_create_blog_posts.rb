class CreateBlogPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_posts do |t|
      t.text :title,      null: false
      t.text :short_text,               comment: 'Excerpt text'
      t.text :full_text,  null: false,  comment: 'Full blog post'
      t.text :image,                    comment: 'Image URL'
      t.integer :author,                comment: 'Published By',    limit: 2
      t.jsonb :colors,    null: false,                              default: '{}'
      t.text :tags, array: true,                                    default: []

      t.timestamps
    end
  end
end
