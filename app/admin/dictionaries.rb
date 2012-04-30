# coding: utf-8
ActiveAdmin.register Dictionary do

  scope :roots, :default => true

  action_item :only => [:show, :edit] do
    link_to 'Добавить', new_admin_dictionary_url( :parent_id => dictionary )
  end

  form do |f|
    f.inputs "Описание" do
      f.input :name
      f.input :tag
      f.input :parent_id, :as => :select, :collection => Dictionary.order(:names_depth_cache).map{ |r| [" --- " * r.depth + r.name, r.id] }
    end
    f.buttons
  end

  controller do

    def new
      @dictionary = Dictionary.new( :parent_id => params[:parent_id] )
      new!
    end

    #def create
    #  @dictionary = Dictionary.new( params[:dictionary] )
    #  create!
    #end

  end
  
end
