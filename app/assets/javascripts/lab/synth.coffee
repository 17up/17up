class window.Synth extends AudioletGroup
	constructor: (audiolet, frequency) ->
		AudioletGroup.apply(@, [audiolet, 0, 1])
		@sine = new Sine(@audiolet, frequency)
		@modulator = new Saw(@audiolet, 2 * frequency)
		@modulatorMulAdd = new MulAdd(@audiolet, frequency / 2,frequency)

		@gain = new Gain(@audiolet)

		ar = ->
			@audiolet.scheduler.addRelative(0,@remove.bind(@))
		@envelope = new PercussiveEnvelope @audiolet,1,0.2,0.5,ar.bind(@)

		@modulator.connect(@modulatorMulAdd)
		@modulatorMulAdd.connect(@sine)
		@envelope.connect(@gain, 0, 1)
		@sine.connect(@gain)
		@gain.connect(@outputs[0])
	@init: ->
		audiolet = new Audiolet()

		cs = (hz) ->
			synth = new Synth(audiolet, hz)
			synth.connect(audiolet.output)

		audiolet.scheduler.addAbsolute 0,(-> cs(270)).bind(@)	
		audiolet.scheduler.addAbsolute 1,(-> cs(410)).bind(@)
		audiolet.scheduler.addAbsolute 2,(-> cs(370)).bind(@)	