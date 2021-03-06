class Book < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  validates :name, :language, :first_numbered_page, presence: true
  validates :name, uniqueness: {scope: :language}
  default_scope {order('id ASC')}
  
  def cover_page
    pages.first
  end

  def first_page
    pages.first_numbered
  end

  def last_page
    pages.last
  end

  def full_name
    "#{name}_#{language}"
  end

  def human_name
    I18n.t("books.#{full_name}")
  end

  def serialize
    self.attributes.merge({
      cover_page: self.cover_page.number,
      first_page: self.first_page.number,
      last_page:  self.last_page.number,
      full_name:  self.full_name,
      human_name: self.human_name
    })
  end

  def self.default
    Book.find_by(name: 'hw4', language: 'en')
  end
end
