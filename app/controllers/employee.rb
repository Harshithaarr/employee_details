class EmployeeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create, :update]

  def create
    employee = Employee.new(verify_employee_params)
    if employee.save
      WebhookEndpoint.create(url: 'https://example.com/webhooks/receive')
      WebhookEvent.create(event: 'create', payload: employee.to_json, webhook_endpoint_id: webhook_endpoint.id)
    end
  end

  def update
    employee = Employee.find(params[:id])
    if employee.update(verify_employee_params)
      WebhookEndpoint.create(url: 'https://example.com/webhooks/receive')
      WebhookEvent.create(event: 'update', payload: employee.to_json, webhook_endpoint_id: webhook_endpoint.id)
    end
  end

  private

  def verify_employee_params
    params.require(:employee).permit(:name, :age, :role, :band)
  end

end