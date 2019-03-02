(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?l - location ?l2 - location)
      :precondition (and (connected ?l ?l2) (at ?r ?l) (no-robot ?l2)  (not(no-robot ?l)))
      :effect (and  (not (no-robot ?l2)) (at ?r ?l2)  (no-robot ?l)  (not (at ?r ?l)) ) 
    )


    (:action robotMoveWithPallette
       :parameters (?r - robot ?l - location ?l2 - location ?p - pallette)
       :precondition (and (connected ?l ?l2) (at ?r ?l)  (at ?p ?l) (no-robot ?l2) (no-pallette ?l2) )
       :effect (and (not (free ?r)) (no-pallette ?l) (no-robot ?l) (not (at ?r ?l)) (not (at ?p ?l))  (at ?r ?l2) (at ?p ?l2) (not (no-robot ?l2)) (not (no-pallette ?l2)) (has ?r ?p))
    )
    
    
    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?sa - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (orders ?o ?sa) (ships ?s ?o) (at ?p ?l) (contains ?p ?sa)  (packing-at ?s ?l) (packing-location ?l))
      :effect (and (not (contains ?p ?sa)) (includes ?s ?sa))
    )

    
    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (packing-location ?l) (not (available ?l))  (packing-at ?s ?l) (ships ?s ?o))
      :effect (and (available ?l) (not (started ?s)) (complete ?s) (not (packing-at ?s ?l)) )
    )

)
