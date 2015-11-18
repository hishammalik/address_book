class ContactsController < ApplicationController
  def index
    @contacts_grid = initialize_grid(Contact, 
      include: [:emails, :phones],
      enable_export_to_csv: true,
      csv_file_name: "contacts-#{Date.today}"
    )
    export_grid_if_requested
  end
    
  def new
    @contact = Contact.new
    @contact.emails.build
    @contact.phones.build
  end
  
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to({action: :index}, notice: I18n.t('activerecord.notice.models.contact.saved'))
    else
      render action: :new
    end        
  end
  
  def show
    @contact = Contact.find(params[:id])
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def update
    @contact = Contact.find(params[:id])
    
    if @contact.update_attributes(contact_params)
      redirect_to({action: :index}, notice: I18n.t('activerecord.notice.models.contact.updated'))
    else
      render action: :edit
    end        
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to({action: :index}, notice: I18n.t('activerecord.notice.models.contact.destroyed'))
  end
    
  def import
    #imports contacts from CSV file uploaded
    errors = Contact.import(params[:file])
    if errors.empty?
      redirect_to({action: :index}, notice: I18n.t('activerecord.notice.models.contact.imported'))
    else
      redirect_to({action: :index}, alert: "#{I18n.t('activerecord.alert.models.contact.imported_with_errors')}: #{errors.join('<br/>')}".html_safe)
    end
  end
  
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, 
      emails_attributes: [:id, :address, :_destroy],
      phones_attributes: [:id, :number, :_destroy]
    )
  end
  private :contact_params
end
