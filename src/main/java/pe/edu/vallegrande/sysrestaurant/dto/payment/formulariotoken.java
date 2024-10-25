package pe.edu.vallegrande.sysrestaurant.dto.payment;

public class formulariotoken {
    private String tokenFormulario;

    public formulariotoken() {
    }

    public formulariotoken(String tokenFormulario) {
        this.tokenFormulario = tokenFormulario;
    }

    public String getTokenFormulario() {
        return tokenFormulario;
    }

    public void setTokenFormulario(String tokenFormulario) {
        this.tokenFormulario = tokenFormulario;
    }
}
