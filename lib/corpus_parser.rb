class CorpusParser
  TagWord = Struct.new(:word, :tag)
  NULL_CHARACTER = "START"
  STOP = " "
  SPLITTER = '/'

  def initialize
    @ngram = 2
  end

  def parse(string)
    ngrams = @ngram.times.map { TagWord.new(NULL_CHARACTER, NULL_CHARACTER) }

    word = ''
    pos = ''
    parse_word = true

    string.each_char do |char|
      if char == "\t"
        next
      elsif char == SPLITTER
        parse_word = false
      elsif char == STOP
        ngrams.shift
        ngrams << TagWord.new(word, pos)

        yield ngrams

        word = ''
        pos = ''
        parse_word = true
      elsif parse_word
        word += char
      else
        pos += char
      end
    end

    unless pos.empty? || word.empty?
      ngrams.shift
      ngrams << TagWord.new(word, pos)
      yield ngrams
    end
  end
end