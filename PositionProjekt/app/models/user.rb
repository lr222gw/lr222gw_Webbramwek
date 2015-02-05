class User < ActiveRecord::Base

  has_secure_password

  validates :email,
            :presence => {:message => "Du måste ange en e-post"},
            :uniqueness => true



  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ , :message => "Du måste ange en giltig e-post"




end
