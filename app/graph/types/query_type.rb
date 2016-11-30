QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "Root query for schema"

  field :organization do
    type OrganizationType
    argument :domain, types.String
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      if args[:id]
        Organization.find(args[:id])
      else
        Organization.find_by_domain(args[:domain])
      end
    }
  end

  field :user do
    type UserType
    argument :id, types.ID
    argument :phone, types.String
    argument :email, types.String
    resolve -> (organization, args, ctx) {
      GrapgqlService.find_by_arguments(
        organization.users,
        args
      )
    }
  end

end
