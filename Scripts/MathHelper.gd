static func map(toMap, rangeStartLow, rangeStartHigh, rangeMapLow, rangeMapHigh):
	return (toMap-rangeStartLow)/(rangeStartHigh-rangeStartLow) * (rangeMapHigh-rangeMapLow) + rangeMapLow
