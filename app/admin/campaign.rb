ActiveAdmin.register Campaign do
  permit_params :name, :send_at, :email_template_id, :category

  index do
    selectable_column
    id_column
    column :name
    column :send_at
    column :email_template
    column :created_at
    column :job_id
    column :category
    actions
  end

  filter :name
  filter :send_at
  filter :email_template
  filter :created_at

  form title: 'Campaign' do |f|
    f.inputs do
      f.input :name
      f.input :send_at, as: :time_picker, :input_html => { :width => 200 }
      f.input :email_template, as: :select, collection: EmailTemplate.all.map {|template| [template.name, template.id]}
      f.input :category, as: :select
    end
    f.actions
  end

end
