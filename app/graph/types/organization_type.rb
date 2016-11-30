OrganizationType = GraphQL::ObjectType.define do
  name "Organization"
  description "Organization for make booking"

  field :workers, types[WorkerType]
  field :id,      types.ID
  field :name,   types.String
  field :domain, types.String
  field :owner,  UserType

  field :appointments do
    type types[AppointmentType]
    description "List of appointments"
    argument :id, types.ID
    argument :status, types.String
    argument :user_id, types.Int
    argument :limit, types.Int
    resolve -> (organization, args, ctx) {
      GraphqlService.find_by_arguments(organization.appointments, args)
    }
  end

  field :workers do
    type WorkerType
    argument :id, types.ID
    argument :is_enabled, types.Boolean
    argument :phone, types.String
    resolve -> (organization, args, ctx) {
      GraphqlService.find_by_arguments(organization.workers, args)
    }
  end

end
