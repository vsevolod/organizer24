# coding: utf-8
class DictionariesController < CompanyController
  before_action :redirect_if_not_owner, except: [:index]
  add_breadcrumb 'На главную', '/'
  add_breadcrumb 'Словари', Dictionary, except: [:index]

  def index
    @dictionaries = @organization.dictionaries.roots
  end

  def new
    @dictionary = @organization.dictionaries.build(dictionary_params)
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
    @dictionary = @organization.dictionaries.build(dictionary_params)
    @dictionary.organization = current_user.my_organization || current_user.worker.try(:organization)
    if @dictionary.save
      redirect_to @dictionary.parent || Dictionary
    else
      render 'new'
    end
  end

  def update
    @dictionary = @organization.dictionaries.find(params[:id])
    if @dictionary.update_attributes(dictionary_params)
      redirect_to @dictionary.parent || Dictionary
    else
      render 'edit'
    end
  end

  def destroy
    @dictionary = @organization.dictionaries.find(params[:id])
    @dictionary.destroy
    redirect_to Dictionary
  end

  private

    def dictionary_params
      params.require(:dictionary).permit([
        :name,
        :tag,
        :ancestry,
        :parent_id,
        :children_dictionaries_attributes
      ])
    rescue ActionController::ParameterMissing
      {}
    end
end
