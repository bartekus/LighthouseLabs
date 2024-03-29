class Footman < Unit

  attr_reader :health_points, :attack_power

  def initialize
    super(60, 10)
  end

  def attack!(enemy)
    unless enemy.is_a?(Barracks)
      raise InvalidTarget, "Cannot attack dead unit!" if enemy.dead?
      raise InvalidCommand, "Cannot issue commands to a dead unit!" if self.dead?
    end

    if enemy.is_a?(Barracks)
      enemy.damage((attack_power / 2).ceil)
    else
      enemy.damage(attack_power)
    end

  end

end
