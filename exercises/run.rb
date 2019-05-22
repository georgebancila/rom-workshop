require "bundler/setup"
require "pry"
require "rom-repository"

require_relative "setup"

require '../exercises/lib/persistence/repositories/articles'
require '../exercises/lib/persistence/repositories/authors'

MIGRATION = Persistence.db.migration do
  change do
    create_table :authors do
      primary_key :id
      column :name, :text, null: false
    end

    create_table :articles do
      primary_key :id
      column :title, :text, null: false
      column :published, :boolean, null: false, default: false
      foreign_key :author_id, :authors
    end
  end
end

# TODO: add exercise code here

if $0 == __FILE__
  # Start with a clean database each time
  Persistence.reset_with_migration(MIGRATION)
  Persistence.finalize

  # TODO: play around here ;)
  articles_repo = Persistence::Repositories::ArticlesRepo.new(Persistence.rom)
  authors_repo = Persistence::Repositories::AuthorsRepo.new(Persistence.rom)

  author = authors_repo.create(name: 'Author one')

  get = articles_repo.create(title: 'Article one', published: true, author_id: author.id)
  articles_repo.create(title: 'Article two', published: false, author_id: author.id)
  article = articles_repo.create(title: 'Article three', published: false, author_id: author.id)

  new_article = articles_repo.update(get.id, title: 'New name')
  get_article = articles_repo.by_pk(article.id)
  articles = articles_repo.listing.to_a

  bam = articles_repo.publish(author,{title:'THIS'})

  articles_before = articles_repo.listing
  articles_repo.unpublish(bam)
  articles_after = articles_repo.listing
  binding.pry
end
