class GenericParser

  def acceptIt
    tok=tokens.shift
    puts "consuming #{tok.val} (#{tok.kind})" if @verbose
    tok
  end

  def showNext k=1
    tokens[k-1]
  end

  def expect kind
    if (actual=showNext.kind)!=kind
      abort "ERROR at #{showNext.pos}. Expecting #{kind}. Got #{actual}"
    else
      return acceptIt()
    end
  end

  def maybe kind
    if showNext.kind==kind
      return acceptIt
    end
    nil
  end

  def more?
    !tokens.empty?
  end

  def lookahead n
    showNext(k=n)
  end

  def niy
    raise "NIY"
  end

  def  next_tokens n=5
    @tokens[0..n].map{|tok| [tok.kind,tok.val].to_s}.join(',')
  end

  def consume_to token_kind
    while showNext && showNext.kind!=token_kind
      acceptIt
    end
    if showNext.nil?
      raise "cannot find token '#{token_kind}'"
    end
  end
  
  def i_am_here
    pp showNext ; abort
  end
end
