# frozen_string_literal: true

class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :verified, as: :boolean
    field :provider, as: :text
    field :uid, as: :text
    field :sessions, as: :has_many
  end
end
