class Widgets
  def self.all
    WIDGETS
  end

  def self.left
    @@left    ||= self.select(:left)
  end

  def self.right
    @@right   ||= self.select(:right)
  end

  def self.center
    @@center  ||= self.select(:center)
  end

  def self.reset
    @@left    = nil
    @@right   = nil
    @@center  = nil
  end

  def self.all_methods
    @@methods ||= begin
      methods = {}
      [self.left, self.right, self.center].each do |widgets|
        widgets.each do |widget|
          widget.methods.select{|m| m.to_s.start_with?('action')}.each do |m|
            methods[m.to_s.gsub('action_','').to_sym] = widget
          end
          if widget.respond_to? :widgets
            widget.widgets.map do |w|
              w.methods.select{|m| m.to_s.start_with?('action')}.each do |m|
                methods[m.to_s.gsub('action_','').to_sym] = w
              end
            end
          end
        end
      end
      methods
    end
  end

  private

  class WidgetList
    def initialize widgets = []
      @widgets = widgets
    end

    def each &block
      @widgets.each(&block)
    end

    def render
      @widgets.map { |w| w.render }.join
    end
  end

  def self.select(align)
    WidgetList.new( self.all.select { |w| w[:align] == align }.map{ |w|
      Kernel.const_get(w[:widget].to_s.split("_").collect(&:capitalize).join).new(w)
    })
  end
end
