class AmfSocket::Serializer
  def self.dump(object)
    return RocketAMF.serialize(object, 3)
  end

  def self.load(bytes)
    return RocketAMF.deserialize(bytes, 3)
  end
end
