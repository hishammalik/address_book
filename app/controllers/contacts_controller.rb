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
      redirect_to({action: :index}, notice: "Contact Saved!")
    else
      render action: :new
    end        
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def update
    @contact = Contact.find(params[:id])
    
    if @contact.update_attributes(contact_params)
      redirect_to({action: :index}, notice: "Contact Saved!")
    else
      render action: :edit
    end        
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to({action: :index}, notice: "Contact Destroyed!")
  end
    
  def import
    #imports contacts from CSV file uploaded
    Contact.import(params[:file])
    redirect_to({action: :index}, notice: "Contacts imported.")
  end
  
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, 
      emails_attributes: [:id, :address, :_destroy],
      phones_attributes: [:id, :number, :_destroy]
    )
  end
  private :contact_params
end
