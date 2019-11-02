class Question
  def initialize(item)
    @item = item
  end

  def question
   @question =
    {
      question: @item.elements['text'].text,
      seconds: @item.attributes["minutes"].to_i,
      points: @item.attributes["points"].to_i,
      right_answer:
        REXML::XPath.first( @item, "*//variant[@right='true']" ).text.to_i
    }
  end
end