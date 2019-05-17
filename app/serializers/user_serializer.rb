class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :actors

  def actors
    self.object.actors.map do |actor|
      ActorSerializer.new(actor)
    end
  end

end
