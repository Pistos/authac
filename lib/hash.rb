class Hash
  def recursive_merge!( h2 )
    h2.each do |k2,v2|
      case v2
      when Hash
        ( self[ k2 ] || {} ).recursive_merge!( h2[ k2 ] )
      else
        self[ k2 ] = h2[ k2 ]
      end
    end
  end
end

