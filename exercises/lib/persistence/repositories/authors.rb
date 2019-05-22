module Persistence
  module Repositories
    class AuthorsRepo < ROM::Repository[:authors]
      commands :create
    end
  end
end