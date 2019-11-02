require "rexml/document"
require "rexml/xpath"
require_relative '../lib/evaluation_of_response'
require_relative '../lib/pluralizer'
require_relative '../lib/question'

class Quiz
  attr_reader :number_of_questions

  def initialize(number_of_questions)
    @number_of_questions = number_of_questions.to_i
    current_path = File.dirname(__FILE__)
    file_name = current_path + "/../data/questions.xml"
    abort "Не удалось найти файл с вопросами" unless File.exist?(file_name)

    # Открываем файл и создаём из его содержимого REXML-объект
    file = File.new(file_name, "r:UTF-8")
    doc = REXML::Document.new(file)
    file.close

    # Теперь мы можем достать любое поле нашей вопроса с помощью методов объекта doc
    # Например, doc.root.elements["text"].text
    # Давайте запишем все поля в ассоциативный массив
    @questions = []
    doc.elements.each("questions/question") do |item|
      item.elements.each("variants/variant") do |element|
        element.attributes["right"] ||= 'false'
        if element.attributes["right"] == 'true'
          @questions << Question.new(item).question
        end
      end
    end
    abort "У нас нет столько вопросов" unless @number_of_questions < @questions.size
  end

  def questions
    @questions.sample(@number_of_questions)
  end

  def ask_question(item)
    "#{item[:question]} (#{item[:points]} #{Pluralizer.endings(item[:points],"балл", "балла", "баллов")}) " +
    "Вам на всё про всё #{item[:seconds]} #{Pluralizer.endings(item[:seconds], 'секунда', 'секунды', 'секунд')}."
  end

  def right_wrong_to_late_answer(item, user_answer, delta)
    if delta < item[:seconds]
      # сравниваем с правильным ответом и сообщаем правильно ответил или нет,
      # запоминаем их количество и сумируем количество набранных баллов
      evaluation_of_response =
        if item[:right_answer] == user_answer
          EvaluationOfResponse.new(1, "Верный ответ!", item[:points])
        else
          EvaluationOfResponse.new(0, "Неправильно. Правильный ответ: #{item[:right_answer]}", 0)
        end
    else
      evaluation_of_response = EvaluationOfResponse.new(0, "Ответ не засчитан, вы слишком долго думали", 0)
    end
  end
end
