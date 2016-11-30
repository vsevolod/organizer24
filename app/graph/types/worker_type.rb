WorkerType = GraphQL::ObjectType.define do
  name "Worker"
  description "Worker of organization"

  field :organization, OrganizationType

  field :id,            types.ID
  field :name,          types.String
  field :is_enabled,    types.Boolean
  field :phone,         types.String
  field :profession,    types.String
  field :dative_case,   types.String
  field :finished_date, types.String
  field :photo,         types.String do
    argument :thumb, !types.String
    resolve -> (obj, args, ctx) {
      obj.photo.url(args[:thumb])
    }
  end
end
