module Persistence
  module Repositories
    class ArticlesRepo < ROM::Repository[:articles]
      commands :create, update: :by_pk

      def by_pk(id)
        articles.published.by_pk(id).combine(:author).map_to(OpenStruct).one
      end

      def listing
        articles.published.combine(:author).map_to(OpenStruct).to_a
      end

      def publish(author, article)
        articles
          .changeset(:create, article)
          .map {|tuple| tuple.merge(published: true)}
          .associate(author)
          .commit
      end

      def unpublish(article)
        articles
          .by_pk(article.id)
          .changeset(:update, article)
          .map {|tuple| tuple.to_h.merge(published: false)}
          .commit
      end
    end
  end
end