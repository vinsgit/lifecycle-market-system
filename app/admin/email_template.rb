ActiveAdmin.register EmailTemplate do
  permit_params :name, :template
  
  index do
    selectable_column
    id_column
    column :name
    column :template
    column :created_at
    actions
  end

  filter :name
  filter :template
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :template, as: :file
    end
    f.actions
  end

  controller do
    def create
      if params.dig(:email_template, :template).blank?
        flash[:error] = 'Update failed: Please upload template file'
        super
      else
        file = File.read(params.dig(:email_template, :template).tempfile)
        template = EmailTemplate.create(
          name: params.dig(:email_template, :name),
          template: file
        )
        flash[:notice] = 'Create success'
        redirect_to admin_email_templates_path
      end
    end

    def update
      name = params.dig(:email_template, :name)
      template = EmailTemplate.find(params.dig(:id))
      template.update(
        name: params.dig(:email_template, :name),
        template: File.read(params.dig(:email_template, :template).tempfile)
      )
      flash[:notice] = 'Update success'
      render :show
    end
  end
end

