UserType = GraphQL::ObjectType.define do
  name "User"
  description "User"

  field :id,        types.ID
  field :email,     types.String
  field :phone,     types.String
  field :firstname, types.String
  field :lastname,  types.String
end
