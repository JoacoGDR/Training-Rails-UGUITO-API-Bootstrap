ActiveAdmin.register Book do
  includes :utility, :user

  filter :utility
  filter :user, as: :select, collection: User.all.map { |user| [user.email, user.id] }
  filter :genre
  filter :author
  filter :title
  filter :publisher
  filter :year

  permit_params = %i[utility_id user_id genre author image title publisher year]

  member_action :copy, method: :get do
    @book = resource.dup
    render :new, layout: false
  end

  controller do
    define_method :permitted_params do
      params.permit(active_admin_namespace.permitted_params, book: permit_params)
    end
  end

  index do
    selectable_column
    id_column
    column :utility
    column :user
    column :genre
    column :author
    column :title
    column :publisher
    column :year
    actions
  end

  form do |f|
    f.inputs 'Book Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :utility
      f.input :user, as: :select, collection: User.all.map { |user| [user.email, user.id] }
      f.input :genre
      f.input :author
      f.input :image
      f.input :title
      f.input :publisher
      f.input :year
    end
    f.actions
  end
end
