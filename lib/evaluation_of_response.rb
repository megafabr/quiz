class EvaluationOfResponse
  attr_reader :yes, :verdict, :sum

  def initialize(yes, verdict, sum)
    @yes = yes.to_i
    @verdict = verdict
    @sum = sum.to_i
  end
end