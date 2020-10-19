window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'toggleHUD':
            $("body").css("display", event.data.show ? "block" : "none");
            
        case 'updateStatusHAOSHud':
            if (event.data.health) {
                $("#health.pie-wrapper").css("display", "block");
                $("#health.pie-wrapper .pie .half-circle").css("border-color", "#2D8738");
                $("#health.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.health * 3.6}deg)`);
                if (event.data.health <= 50) {
                    $("#health.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#health.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#health.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#health.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#health.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.health == false) {
                $("#health.pie-wrapper").css("display", "none");
            }

            if (event.data.armor) {
                $("#armor.pie-wrapper").css("display", "block");
                $("#armor.pie-wrapper .pie .half-circle").css("border-color", "#5598ff");
                $("#armor.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.armor * 3.6}deg)`);
                if (event.data.armor <= 50) {
                    $("#armor.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#armor.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#armor.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#armor.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#armor.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.armor == false) {
                $("#armor.pie-wrapper").css("display", "none");
            }

            if (event.data.oxygen) {
                $("#oxygen.pie-wrapper").css("display", "block");
                $("#oxygen.pie-wrapper .pie .half-circle").css("border-color", "#614C75");
                $("#oxygen.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.oxygen * 3.6}deg)`);
                if (event.data.oxygen <= 50) {
                    $("#oxygen.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#oxygen.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#oxygen.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#oxygen.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#oxygen.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.oxygen == false) {
                $("#oxygen.pie-wrapper").css("display", "none");
            }

            if (event.data.stamina) {
                $("#stamina.pie-wrapper").css("display", "block");
                $("#stamina.pie-wrapper .pie .half-circle").css("border-color", "#C03B3B");
                $("#stamina.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.stamina * 3.6}deg)`);
                if (event.data.stamina <= 50) {
                    $("#stamina.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#stamina.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                    $("#stamina.pie-wrapper .pie .right-side").css("transform", ``);
                } else {
                    $("#stamina.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#stamina.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#stamina.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.stamina == false) {
                $("#stamina.pie-wrapper").css("display", "none");
                
            }

            if (event.data.parachute) {
                $("#parachute.pie-wrapper").css("display", "block");
                $("#parachute.pie-wrapper .pie .half-circle").css("border-color", "#00FFD4");
                $("#parachute.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.parachute * 3.6}deg)`);
                if (event.data.parachute <= 50) {
                    $("#parachute.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#parachute.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#parachute.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#parachute.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#parachute.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.parachute == false) {
                $("#parachute.pie-wrapper").css("display", "none");
            }
            break;
        case 'updateStatusHTHud':
            if (event.data.hunger) {
                $("#hunger.pie-wrapper").css("display", "block");
                $("#hunger.pie-wrapper .pie .half-circle").css("border-color", "#d19d47");
                $("#hunger.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.hunger * 3.6}deg)`);
                if (event.data.hunger <= 50) {
                    $("#hunger.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#hunger.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#hunger.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#hunger.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#hunger.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            }

            if (event.data.thirst) {
                $("#thirst.pie-wrapper").css("display", "block");
                $("#thirst.pie-wrapper .pie .half-circle").css("border-color", "#1D91D9");
                $("#thirst.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.thirst * 3.6}deg)`);
                if (event.data.thirst <= 50) {
                    $("#thirst.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#thirst.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#thirst.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#thirst.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#thirst.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            }
            break;
        case 'updateStatusFKHud':
            if (event.data.km) {
                $("#km.pie-wrapper .label").html(`${event.data.km}<span class="smaller">km</span>`);
                $("#km.pie-wrapper").css("display", "block");
                $("#km.pie-wrapper .pie .half-circle").css("border-color", "#FF4900");
                $("#km.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.km * 3.6}deg)`);
                if (event.data.km <= 50) {
                    $("#km.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#km.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#km.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#km.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#km.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.km == false) {
                $("#km.pie-wrapper").css("display", "none");
            }

            if (event.data.fuel) {
                $("#fuel.pie-wrapper .label").html(`${event.data.fuel}<span class="smaller">yakıt</span>`);
                $("#fuel.pie-wrapper").css("display", "block");
                $("#fuel.pie-wrapper .pie .half-circle").css("border-color", "#FFF700");
                $("#fuel.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.fuel * 3.6}deg)`);
                if (event.data.fuel <= 50) {
                    $("#fuel.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#fuel.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#fuel.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#fuel.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#fuel.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.fuel == false) {
                $("#fuel.pie-wrapper").css("display", "none");
            }

            if (event.data.enginehealth) {
                $("#enginehealth.pie-wrapper").css("display", "block");
                $("#enginehealth.pie-wrapper .pie .half-circle").css("border-color", "#FF2300");
                $("#enginehealth.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.enginehealth * 3.6}deg)`);
                if (event.data.enginehealth <= 50) {
                    $("#enginehealth.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#enginehealth.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                    $("#enginehealth.pie-wrapper .pie .right-side").css("transform", ``);
                } else {
                    $("#enginehealth.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#enginehealth.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#enginehealth.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.enginehealth == false) {
                $("#enginehealth.pie-wrapper").css("display", "none");
                
            }
            break;
        case 'updateSeatbeltHud':
            if (event.data.seatbelt) {
                $("#seatbelt.pie-wrapper").css("display", "block");
                $("#seatbelt.pie-wrapper .pie .half-circle").css("border-color", "#FFC100");
                $("#seatbelt.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.seatbelt * 3.6}deg)`);
                if (event.data.seatbelt <= 50) {
                    $("#seatbelt.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#seatbelt.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#seatbelt.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#seatbelt.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#seatbelt.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.seatbelt == false) {
                $("#seatbelt.pie-wrapper").css("display", "none");
            }
            break;
        case 'updateCruiseHud':
            if (event.data.cruisecontrol) {
                $("#cruisecontrol.pie-wrapper .label").html(`<span class="icon" style="font-size: 90%; padding-right: 2px;"><i class="fas fa-tachometer-alt"></i></span><span style="font-size: 80%;">${event.data.cruisecontrol}</span>`);
                $("#cruisecontrol.pie-wrapper").css("display", "block");
                $("#cruisecontrol.pie-wrapper .pie .half-circle").css("border-color", "#FF0036");
                $("#cruisecontrol.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.cruisecontrol * 3.6}deg)`);
                if (event.data.cruisecontrol <= 50) {
                    $("#cruisecontrol.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#cruisecontrol.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#cruisecontrol.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#cruisecontrol.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#cruisecontrol.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.cruisecontrol == false) {
                $("#cruisecontrol.pie-wrapper").css("display", "none");
            }
            break;
        case "updateCSTHud":
            if (event.data.direction) {
                $(".direction").css("display", "block");
                $(".direction").find(".image").attr('style', 'transform: translate3d(' + event.data.direction + 'px, 0px, 0px)');
            } else {
                $(".direction").css("display", "none");
            }
            if (event.data.time) {
                $(".time").css("display", "block");
                $(".time").html(event.data.time);
            } else {
                $(".time").css("display", "none");
            }
            if (event.data.street) {
                $(".street-txt").css("display", "block");
                $(".street-txt").html(event.data.street);
            } else {
                $(".street-txt").css("display", "none");
            }
            break;
        case "toggleCircle":
            if (event.data.value == 'hide') {
                $(".outline").css("display", "none");
            } else {
                $(".outline").css("display", "block");
            }
            break;

        case "setVoipMode1":
            $(".talkcircle1").css("border", "5px solid rgb(255, 255, 255)");
            $(".talkcircle2").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipMode2":
            $(".talkcircle1").css("border", "5px solid rgb(255, 255, 255)");
            $(".talkcircle2").css("border", "5px solid rgb(255, 255, 255)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipMode3":
            $(".talkcircle1").css("border", "5px solid rgb(255, 255, 255)");
            $(".talkcircle2").css("border", "5px solid rgb(255, 255, 255)");
            $(".talkcircle3").css("border", "5px solid rgb(255, 255, 255)");
            break;

        case "setVoipTalking1":
            $(".talkcircle1").css("border", "5px solid rgb(181, 69, 247)");
            $(".talkcircle2").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipTalking2":
            $(".talkcircle1").css("border", "5px solid rgb(181, 69, 247)");
            $(".talkcircle2").css("border", "5px solid rgb(181, 69, 247)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipTalking3":
            $(".talkcircle1").css("border", "5px solid rgb(181, 69, 247)");
            $(".talkcircle2").css("border", "5px solid rgb(181, 69, 247)");
            $(".talkcircle3").css("border", "5px solid rgb(181, 69, 247)");
            break;

        case "setVoipTalkingOnRadio1":
            $(".talkcircle1").css("border", "5px solid rgb(245, 103, 8)");
            $(".talkcircle2").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipTalkingOnRadio2":
            $(".talkcircle1").css("border", "5px solid rgb(245, 103, 8)");
            $(".talkcircle2").css("border", "5px solid rgb(245, 103, 8)");
            $(".talkcircle3").css("border", "5px solid rgba(255, 255, 255, 0.5)");
            break;
        case "setVoipTalkingOnRadio3":
            $(".talkcircle1").css("border", "5px solid rgb(245, 103, 8)");
            $(".talkcircle2").css("border", "5px solid rgb(245, 103, 8)");
            $(".talkcircle3").css("border", "5px solid rgb(245, 103, 8)");
            break;
    }
});