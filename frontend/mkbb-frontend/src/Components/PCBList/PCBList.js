import "./styles.css";
import NavbarComp from "../NavbarComponent";

function PCBList() {
    return(
        <div>
            <NavbarComp></NavbarComp>
            <h1>PCB</h1>
            <table border="1">
                <thead>
                    <tr>
                        <td>PartID</td>
                        <td>Name</td>
                        <td>Brand</td>
                        <td>Price</td>
                        <td>Url</td>
                        <td>Contains RGB</td>
                        <td>HotSwappable</td>
                        <td>Connection Type</td>
                        <td>Size</td>
                        <td>Username</td>
                    </tr>
                </thead>
                <tr>
                    <td>PartID</td>
                    <td>Name</td>
                    <td>Brand</td>
                    <td>Price</td>
                    <td>Url</td>
                    <td>Contains RGB</td>
                    <td>HotSwappable</td>
                    <td>Connection Type</td>
                    <td>Size</td>
                    <td>Username</td>
                </tr>
                <tr>
                    <td>PartID</td>
                    <td>Name</td>
                    <td>Brand</td>
                    <td>Price</td>
                    <td>Url</td>
                    <td>Contains RGB</td>
                    <td>HotSwappable</td>
                    <td>Connection Type</td>
                    <td>Size</td>
                    <td>Username</td>
                </tr>
                <tr>
                    <td>PartID</td>
                    <td>Name</td>
                    <td>Brand</td>
                    <td>Price</td>
                    <td>Url</td>
                    <td>Contains RGB</td>
                    <td>HotSwappable</td>
                    <td>Connection Type</td>
                    <td>Size</td>
                    <td>Username</td>
                </tr>
            </table>
        </div>
    )
}
export default PCBList;