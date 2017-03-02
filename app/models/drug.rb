class Drug < RDFClass

  # def to_param
  #   uuid
  # end

  def self.find_by_term(t)
    split_term = t.split(' ')
    Drug.all(:c)
      .where("all(t in {terms} where c.label =~ ('(?i).*' + t + '.*'))")
      .params(terms: split_term)
  end

end
