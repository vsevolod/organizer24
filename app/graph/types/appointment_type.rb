AppointmentType = GraphQL::ObjectType.define do
  name "Appointment"
  description "Appointment user with current worker of organization"

  field :user, UserType
  field :worker, WorkerType
  field :organization, OrganizationType

  field :id,     types.ID
  field :status, types.String
  field :phone,  types.String
  field :start,  types.String
  field :showing_time, types.Int
end
