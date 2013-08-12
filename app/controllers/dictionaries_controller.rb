# coding: utf-8
class DictionariesController < CompanyController

  before_filter :redirect_if_not_owner, :except => [:index]
  add_breadcrumb 'На главную', '/'
  add_breadcrumb 'Словари', Dictionary, :except => [:index]

  def index
    @dictionaries = @organization.dictionaries.roots
  end

  def new
    @dictionary = @organization.dictionaries.build( params[:dictionary] )
  end

  def edit
    @dictionary = @organization.dictionaries.find(params[:id])
  end

  def show
    @dictionary = @organization.dictionaries.find(params[:id])
    add_breadcrumb @dictionary.name, @dictionary
    @dictionaries = @dictionary.children
  end

  def create
    @dictionary = @organization.dictionaries.build( params[:dictionary] )
    @dictionary.organization = current_user.my_organization || current_user.worker.try(:organization)
    if @dictionary.save
      redirect_to @dictionary.parent || Dictionary
    else
      render 'new'
    end
  end

  def update
    @dictionary = @organization.dictionaries.find( params[:id] )
    @dictionary.attributes = params[:dictionary]
    if @dictionary.save
      redirect_to @dictionary.parent || Dictionary
    else
      render 'edit'
    end
  end

  def destroy
    @dictionary = @organization.dictionaries.find( params[:id] )
    @dictionary.destroy
    redirect_to Dictionary
  end

end
