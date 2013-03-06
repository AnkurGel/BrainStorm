module DefaultPagesHelper
  def donut_chart(colleges)
    colleges.map do |c|
      { label: c[:college],
        value: c[:id]
      }
    end
  end
end
