class CompaniesController < ApplicationController

	before_action :authenticate_user!

	def new

	end

	def create
		@company = Company.new(company_params)
    if @company.save
    	if(current_user.admin_id == current_user.id)
	    	current_user.company_id = @company.id
	    	current_user.save
	    	@users = User.where("admin_id = ?",current_user.id)
	    	for user in @users
	    		user.company_id = @company.id
	    		user.save
	    	end
    	end
      flash[:success] = "Company created successfully" 
      flash[:error] = nil 
    else
      flash[:error] = "Company not saved because: #{@company.errors.full_messages.join(',')}"    
    	flash[:success] = nil
    end
	end

	def update
		@company = Company.find(params[:id].to_i)
		@company.attributes = company_params
    if @company.save
      flash[:success] = "Company updated successfully"  
    else
      flash[:error] = "Company not updated because: #{@company.errors.full_messages.join(',')}"    
    end
	end

	protected

  def company_params
    params.require(:company).permit(:name)
  end

end
