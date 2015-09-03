#!/usr/bin/env ruby
module WordNet

  class Dictionary

    def search(word)
      @path = 'data/wordnet'
      return "could not find word database" unless File.exist?("#{@path}/index.adv")
      str = ''
      ['noun','verb','adj','adv'].each{|type| str += define(word,type) }
      return str != '' ? str : "no match"
    end

  private

    def define(word, type)
      # look up the word in the index file, entries comes in the form:
      # lemma pos synset_cnt p_cnt [ptr_symbol...] sense_cnt tagsense_cnt synset_offset [synset_offset...]
      # eg: film n 5 6 @ ~ %p + ; - 5 4 06613686 06262567 03338821 03338648 03339296
      entry = lookup(word, type)
      return '' if entry == ''
      ret = ''
      defCount = 0
      data = File.open("#{@path}/data.#{type}", "r")
      iparts = entry.split(' ')
      p_cnt = iparts[3].to_i
      (6+p_cnt..iparts.length-1).each do |n|
        next unless iparts[n]
        # Byte offset in data files, 8 digit, zero-filled
        synset_offset = iparts[n].to_i
        data.seek(synset_offset, IO::SEEK_SET)
        line = data.readline.strip
        next if line == ''
        defCount += 1
        # data file format:
        # synset_offset lex_filenum ss_type w_cnt word lex_id [word lex_id...] p_cnt [ptr...] [frames...] | gloss
        # eg: 03338648 06 n 01 film 0 004 @ 00002684 n 0000 ~ 04157703 n 0000 ~ 04237654 n 0000 ~ 04254205 n 0000 | a thin coating or layer; "the table was covered with a film of dust"
        dparts = line.split(' ')
        w_cnt = dparts[3].to_i
        synonyms = []
        (4...4 + 2*w_cnt).step(2) {|j| synonyms.push(dparts[j]) }
        synonyms -= [word]
        gloss = line.split('|')[1].strip
        gloss += " [#{synonyms.join(', ')}]" if synonyms.length > 0
        ret += "(#{type}) #{defCount}. #{gloss}\n"
      end
      data.close
      return ret
    end

    def lookup(word, type)
      f = File.open("#{@path}/index.#{type}", "r")
      f.each {|line| return line if line =~ /^#{word}\s/ }
      return ''
    end

  end

  def self.define(word)
    return Dictionary.new.search word.downcase
  end

end

if __FILE__ == $0
  puts WordNet::define ARGV[0] || "test"
end
