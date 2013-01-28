class ChangeSubdomainToDomainForOrganizations < ActiveRecord::Migration
  def up
    rename_column :organizations, :subdomain, :domain
  end

  def down
    rename_column :organizations, :domain, :subdomain
  end
end
